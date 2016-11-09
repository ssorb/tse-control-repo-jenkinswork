define rgbank::db (
  $user,
  $password,
) {
  $db_name = "rgbank-${name}"

  #Needed for the latest SQL file
  vcsrepo { "/var/lib/${db_name}":
    ensure   => latest,
    source   => 'https://github.com/puppetlabs-pmmteam/rgbank.git',
    provider => git,
    before   => Mysql::Db[$db_name],
  }

  mysql::db { $db_name:
    user     => $user,
    password => $password,
    host     => '%',
    sql      => "/var/lib/${db_name}/rgbank.sql",
  }

  mysql_user { "${user}@localhost":
    ensure        => 'present',
    password_hash => mysql_password($password),
  }
}

Rgbank::Db produces Mysqldb {
  database => "rgbank-${name}",
  host     => $ec2_metadata ? {
    undef   => $::facts['networking']['interfaces']['enp0s8']['ip'],
    default => $ec2_metadata['public-ipv4'],
  },
  user     => $user,
  password => $password
}
