name             "logentries"
maintainer       "James Gregory"
maintainer_email "james@jagregory.com"
license          "MIT"
description      "Installs and manages Logentries."
long_description IO.read(File.join(File.dirname(__FILE__), "README.md"))
version          "0.1.4"

recipe "logentries", "Set up the apt repository and install the logentries package"

depends "apt"
depends "yum"

%w{ubuntu amazon}.each do |os|
  supports os
end

provides "logentries"
provides "service[logentries]"
