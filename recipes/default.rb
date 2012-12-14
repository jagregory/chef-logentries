include_recipe 'apt'

apt_repository 'logentries' do
  uri 'http://rep.logentries.com/'
  components ['precise', 'main']
  keyserver 'pgp.mit.edu'
  key 'C43C79AD'
end

package 'logentries-daemon'
