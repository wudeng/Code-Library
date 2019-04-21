var dbs = db.getMongo().getDBNames()
for(var i in dbs){
    _db = db.getMongo().getDB( dbs[i] );
    if (_db.getName() !== 'admin' && _db.getName() !== 'local')
    {
        print( "dropping db " + _db.getName() );
        _db.dropDatabase();
    }
}
