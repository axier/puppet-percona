module Puppet::Parser::Functions

  newfunction(:percona_hash_merge, :type => :rvalue, :doc => <<-EODOC
  Prints out a percona hash including the section heads. You can specify which
  sections you want to print as a second argument. If it is not provided, all
  sections will be printed that have been found in the hash.
EODOC

  ) do |args|


    raise(Puppet::ParseError, "percona_hash_merge(): the arguments should be and array. ") unless args.is_a?(Array)
    raise(Puppet::ParseError, "percona_hash_merge(): Two arguments are required. ") if args.length < 2

    result = Hash.new

    args.each do |arg|
      next if arg.is_a? String and arg.empty?
      unless arg.is_a?(Hash)
        raise(Puppet::ParseError, "percona_hash_merge(): All arguments should be Hashes.")
      end
      hash_merge(result, arg)
    end
    return result
  end
end

def hash_merge( hash1, hash2 )
  hash2.each do |k, v|
    if (hash1.has_key?( k ) and v.is_a?(Hash) and hash1[k].is_a?(Hash))
      hash_merge(hash1[k],v)
    else
      hash1[k] = v
    end
  end
end



