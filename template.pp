#
#  Author: Hari Sekhon
#  Date: [% DATE # 2010-05-13 14:34:58 +0100 (Thu, 13 May 2010) %]
#
#  [% VIM_TAGS %]
#
#  [% URL %]
#
#  [% LICENSE %]
#
#  [% MESSAGE %]
#
#  [% LINKEDIN %]
#

class NAME ($version = installed){

    package { "NAME":
        ensure => $version;
    }

    file { "NAME.conf":
        owner   => "root",
        group   => "root",
        mode    => "0400",
        require => Package["NAME"],
        source  => "puppet:///modules/NAME/NAME.conf";
    }

    service { "NAME":
        enable    => true,
        ensure    => running,
        subscribe => File["NAME.conf"];
    }

}
