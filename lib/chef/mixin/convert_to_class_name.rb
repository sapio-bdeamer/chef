#
# Author:: Adam Jacob (<adam@chef.io>)
# Author:: Christopher Walters (<cw@chef.io>)
# Copyright:: Copyright (c) Chef Software Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class Chef
  module Mixin
    module ConvertToClassName
      extend self

      def convert_to_class_name(str)
        str = normalize_snake_case_name(str)
        rname = nil
        regexp = /^(.+?)(_(.+))?$/

        mn = str.match(regexp)
        if mn
          rname = mn[1].capitalize

          while mn && mn[3]
            mn = mn[3].match(regexp)
            rname << mn[1].capitalize if mn
          end
        end

        rname
      end

      def convert_to_snake_case(str, namespace = nil)
        str = str.dup
        str.sub!(/^#{namespace}(\:\:)?/, "") if namespace
        str.gsub!(/[A-Z]/) { |s| "_" + s }
        str.downcase!
        str.sub!(/^\_/, "")
        str
      end

      def normalize_snake_case_name(str)
        str = str.dup
        str.gsub!(/[^A-Za-z0-9_]/, "_")
        str.gsub!(/^(_+)?/, "")
        str
      end

      def snake_case_basename(str)
        with_namespace = convert_to_snake_case(str)
        with_namespace.split("::").last.sub(/^_/, "")
      end

      def filename_to_qualified_string(base, filename)
        file_base = File.basename(filename, ".rb")
        str = base.to_s + (file_base == "default" ? "" : "_#{file_base}")
        normalize_snake_case_name(str)
      end
    end
  end
end
