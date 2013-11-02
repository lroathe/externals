require 'git_repository'
require 'some_subproject_with_edge'

module Externals
  module Test
    class EnginesWithBranch1 < GitRepository
      def initialize
        super "engines", File.join("git", "with_branch1")
        dependents.merge!(
          :other_engines => SomeSubprojectWithEdge.new
        )
      end

      #builds the test repository in the current directory
      def build_here
        rm_rf_ie name

        puts `git clone --bare #{dependents[:other_engines].clean_dir} #{name}.git`
        raise unless $? == 0

        rm_rf_ie "workdir"
        mkdir "workdir"
        Dir.chdir 'workdir' do
          `git clone #{clean_dir}`
          raise unless $? == 0
          Dir.chdir name.gsub(".git", "") do
            `git push origin master:branch1`
            raise unless $? == 0
          end
        end
        rm_rf_ie "workdir"
      end

    end
  end
end