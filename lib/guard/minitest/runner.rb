# encoding: utf-8
module Guard
  class Minitest
    class Runner
      class << self
        attr_reader :seed

        def set_seed(options = {})
          @seed = options[:seed] ||= default_seed
        end

        def run(paths, options = {})
          system(minitest_command(paths))
        end

        private

        def minitest_command(paths)
          cmd_parts = []
          cmd_parts << "bundle exec" if bundler?
          cmd_parts << 'ruby -Itest -Ispec'
          cmd_parts << '-r bundler/setup' if bundler?
          paths.each do |path|
            cmd_parts << "-r #{path}"
          end
          cmd_parts << '-e \'MiniTest::Unit.autorun\''
          cmd_parts << '--'
          cmd_parts << "--seed #{seed}"
          cmd_parts.join(' ')
        end

        def bundler?
          @bundler ||= File.exist?("#{Dir.pwd}/Gemfile")
        end

        def default_seed
          srand
          srand % 0xFFFF
        end
      end
    end
  end
end

