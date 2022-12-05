#!/usr/bin/perl
use strict;
use warnings;
use CGI;

print "Content-type: text/html\n\n";
print <<HTML;
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <link rel="stylesheet" type="text/css" href="../estilos.css">
    <title>Consultas sobre el archivo de universidades licenciadas</title>
  </head>
<body>
HTML
my $q = CGI->new;
my $kind = $q->param("kind");
#my $kind = "nombre";
my $keyword = $q->param("keyword");
#my $keyword = "UNIVERSIDAD PERUANA";
my $flag;
if(!($kind eq "") && !($keyword eq "")){
  open(IN,"../data/datos.txt") or die "<h1>ERROR: open file</h1>\n";
  while(my $line = <IN>){
    my %dict = matchLine($line);
    my $value = $dict{$kind};
    if(defined($value) && $value =~ /.*$keyword.*/){
      print "<p>Encontrado: $line</p>\n";
      $flag = 1;
      next; #continue the loop
    }
  }
  close(IN);
}
if(!defined($flag)){
  print "<h1>No encontrado</h1>\n";
}
print <<HTML;
      Ingrese <a href="../consulta.html">aqui</a> para regresar al formulario de búsqueda
    </body>
  </html>
HTML
sub matchLine{
  my %dict = ();
  my $line = $_[0];
  if( $line =~ m/^([^\|]+)\|([^\|]+)\|(([^\|]+)\|){2}([^\|]+)\|(([^\|]+)\|){5}([^\|]+)\|(([^\|]+)\|){5}([^\|]+)\|/){
    $dict{"nombre"} = $2;
    $dict{"periodo"} = $5;
    $dict{"dpto"} = $8;
    $dict{"denom"} = $11;
  }else{
    print "<h1>Error la linea no hace match: $line</h1>\n";
  }
  return %dict;
}
