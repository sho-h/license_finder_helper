require "license_finder/license"

module LicenseFinder
  class License
    # TODO: add incompatible licenses. now only famous one
    INCOMPATIBLE_LICENSES = {
      "Apache2" => [License.find_by_name("GPLv2")],
      "BSD"     => [License.find_by_name("GPLv2"), License.find_by_name("GPLv3")],
      "GPLv2"   => [License.find_by_name("Apache2"), License.find_by_name("BSD")],
      "GPLv3"   => [License.find_by_name("BSD")],
      "ISC"     => [],
      "LGPL"    => [],
      "MIT"     => [],
      "MPL2"    => [],
      "NewBSD"  => [],
      "Python"  => [],
      "Ruby"    => [],
      "SimplifiedBSD" => [],
    }

    def incompatible_licenses
      key = self.instance_variable_get(:@short_name)
      INCOMPATIBLE_LICENSES[key]
    end

    def compatible_licenses
      INCOMPATIBLE_LICENSES.keys.map { |key| License.find_by_name(key) } - incompatible_licenses
    end
  end
end
