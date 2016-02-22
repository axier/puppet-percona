module Puppet::Parser::Functions

  newfunction(:percona_hash_print, :type => :rvalue, :doc => <<-EODOC

  Prints out a percona hash including the section heads. You can specify which
  sections you want to print as a second argument. If it is not provided, all
  sections will be printed that have been found in the hash.

EODOC
  ) do |args|

    raise(Puppet::ParseError, "percona_hash_print(): Required a hash to work") unless args[0].is_a?(Hash)
    hash = args[0]


    results = []
    hash.sort.map do |k,v|
      if k == ''
        raise(Puppet::ParseError, "percona_hash_print(): Section could not be empty")
      end
      tmp = []
      tmp << "[#{k}]"
      if v.is_a?(Hash)
        v.sort.map do |ki,vi|
          if vi == :undef
            tmp << "#{ki}"
          elsif vi.is_a?(Array)
            vii = vi.join(",")
            tmp << "#{ki} = #{vii}"
          else
            tmp << "#{ki} = #{vi}"
          end
        end
      end
      tmp << ""
      tmp.flatten!
      results << tmp.join("\n")
    end
    results.join("\n")
  end
end
