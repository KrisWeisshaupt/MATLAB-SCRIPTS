tic
FID  = fopen( 'Tex_01.csv' ) ;
line  = fgetl( FID ) ;
row   = sscanf( line, '%f,' )' ;
tex = reshape(row,5439,[]);
fclose(FID);

x=linspace(1,size(tex,1),544);
y=linspace(1,size(tex,2),548); F=griddedInterpolant(tex);
 tex_new = F({x,y});

FID  = fopen( 'Untex_01.csv' ) ;
line  = fgetl( FID ) ;
row   = sscanf( line, '%f,' )' ;
untex = reshape(row,5416,[]);
fclose(FID);

x=linspace(1,size(untex,1),542);
y=linspace(1,size(untex,2),547); F=griddedInterpolant(untex);
 untex_new = F({x,y});
 toc