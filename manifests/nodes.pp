
node 'puppetmaster' {
	include git
}

node 'client.puppet.dev' {
	include git
}
