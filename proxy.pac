function FindProxyForURL(url, host)
{
   if(host.match(/^(localhost|127[.]0[.]0[.]1|192[.]168[.]1[.]1)$/))
       return 'DIRECT';
   if(host.match(/[.]i2p$/))
       return 'PROXY 127.0.0.1:4444';

   return 'SOCKS 127.0.0.1:9050';
}
