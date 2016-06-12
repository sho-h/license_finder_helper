require 'license_finder'
require 'license_finder/license'
require 'license_finder_helper/extend_license_finder'

module LicenseFinderHelper
  class Cli
    def run
      print "Will you publish this gem as Open Source Software?(Y/n): "
      if yes_or_no
        licenses = self_licenses
        case licenses.length
        when 0
          warn "YOUR OPEN SOURCE SOFTWARE HAS NO LICENSE!!!"
        when 1
          # add self to whitelist
          license = self_licenses.first
          system("license_finder", "whitelist", "add", license)

          # add self's incompatibles to blacklist
          LicenseFinder::License.find_by_name(license).incompatible_licenses.each do |l|
            system("license_finder", "blacklist", "add", l.name)
          end
=begin
          # warn violation
          Gem.loaded_specs.each do |name, spec|
            l = LicenseFinder::License.find_by_name(spec.license)
            if l.incompatible_licenses && l.incompatible_licenses.include?(license)
              warn "Your software violates with #{l}, change either license."
            end
          end
=end
        end
      else
        puts "Your software must be disclosure sourcecode for user's request " +
             "if you use GPL libraries"
        system("license_finder", "blacklist", "add", "GPLv2")
        system("license_finder", "blacklist", "add", "GPLv3")
      end
    end

    def yes_or_no
      return /^(y|Y|yes|YES|Yes|\s*)$/.match(gets)
    end

    def self_licenses
      if path = Dir.glob(File.join(Bundler.root, "/*.gemspec")).first
        return Bundler.load_gemspec(path).licenses
      end
      return []
    end

    def gpl?
      licenses = self_licenses
      return licenses.length == 1 && /^gpl/i.match(licenses.first)
    end
  end
end
