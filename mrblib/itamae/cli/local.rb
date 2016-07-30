module Itamae
  class CLI
    class Local
      DEFAULT_OPTIONS = {
        node_json: nil,
        node_yaml: nil,
        dry_run:   false,
        shell:     '/bin/sh',
        log_level: 'info',
      }

      def initialize(args)
        @options = DEFAULT_OPTIONS.dup
        @recipe_paths = parse_options(args)
      end

      def run
        if @recipe_paths.empty?
          puts 'Please specify recipe files.'
          exit 1
        end

        Itamae.logger = Logger.new(@options[:log_level])
        Itamae.logger.info 'Starting Itamae...'

        runner = Runner.new(@options[:node_json], @options[:node_yaml])
        runner.load_recipes(@recipe_paths)
        runner.run(
          dry_run: @options[:dry_run],
          shell:   @options[:shell],
        )
      end

      private

      def parse_options(args)
        opt = OptionParser.new
        opt.on('-j VAL', '--node-json=VAL') { |v| @options[:node_json] = v }
        opt.on('-y VAL', '--node-yaml=VAL') { |v| @options[:node_yaml] = v }
        opt.on('-n', '--dry-run') { |v| @options[:dry_run] = v }
        opt.on('--shell=VAL')     { |v| @options[:shell] = v }
        opt.on('--log-level=VAL') { |v| @options[:log_level] = v }
        opt.parse!(args.dup)
      end
    end
  end
end
