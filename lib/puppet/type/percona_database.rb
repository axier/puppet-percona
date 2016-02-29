# This has to be a separate type to enable collecting
Puppet::Type.newtype(:percona_database) do
  @doc = "Manage a database."

  ensurable

  newparam(:name, :namevar=>true) do
    desc "The name of the database."
    validate do |value|
      unless value =~ /^\w+/
        raise ArgumentError, "%s is not a valid database name" % value
      end
    end
  end
  newparam(:mgmt_cnf) do
    desc "The my.cnf to use for calls."
  end

  newproperty(:charset) do
    desc "The characterset to use for a database"
    defaultto :utf8
    newvalue(/^\S+$/)
  end

  newproperty(:collate) do
    desc "The collate to use for a database"
    defaultto :utf8_general_ci
    newvalue(/^\S+$/)
  end

end

