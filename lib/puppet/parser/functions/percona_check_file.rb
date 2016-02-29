module Puppet::Parser::Functions

  newfunction(:percona_check_file, :type => :rvalue, :doc => <<-EODOC
  Prints out a percona hash including the section heads. You can specify which
  sections you want to print as a second argument. If it is not provided, all
  sections will be printed that have been found in the hash.
EODOC

  ) do |args|


    raise(Puppet::ParseError, "percona_check_file(): one argument is required. ") unless args.length == 1

    if File.exist?(args[0])
        return 1
    else
        return 0
    end
  end
end
