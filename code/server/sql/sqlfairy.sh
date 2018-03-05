# apt install graphviz
# apt install libgd2-xpm-dev # needed for gd
# apt install libsql-translator-perl
sqlt-graph   -f MySQL -o fulla-graph.png -t png db.sql 
sqlt-diagram -f MySQL -o fulla-diagram.png -t png db.sql
