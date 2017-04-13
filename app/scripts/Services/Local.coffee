angular.module('feryzApp')

.factory('Local', ['App', '$http', '$q', '$timeout', (App, $http, $q, $timeout) ->

	
	tx = {}
	


	db = window.openDatabase("MyVc.db", '1', 'My Virtual College', 1024 * 1024 * 5);
	db.transaction( (tX)->
		tx = tX;
	);


	sqlEntradas = "CREATE TABLE IF NOT EXISTS entradas (id integer," +
					"fecha date DEFAULT NULL ," +
					"tipo varchar(100)  DEFAULT NULL collate nocase," +
					"proveedor_id integer DEFAULT NULL," +
					"cancelada integer DEFAULT NULL," +
					"created_at date DEFAULT NULL)";
	sqlEnt_detall = "CREATE TABLE IF NOT EXISTS entradas_detalles (id integer," +
					" entrada_id integer DEFAULT NULL," +
					" producto_id integer DEFAULT NULL," +
					"cantidad integer default NULL," +
					"precio_costo decimal(11,3) default NULL," +
					"precio_venta decimal(11,3) default NULL," +
					" nombre_grupo varchar(100) default NULL)";
	
	res = {

		createTables: ()->
			defered = $q.defer();

			db.transaction( (tx) ->
				tx.executeSql(sqlEntradas, [],  (tx, result) ->
				  console.log('Tabla entradas creada');
				, (tx,error)->
				  console.log("Tabla entradas NO se pudo crear", error.message);
				)
				tx.executeSql(sqlEnt_detall, [],  (tx, result) ->
				  console.log('Tabla entradas_detalles creada');
				  defered.resolve('Hasta tabla entradas creada');
				, (tx,error)->
				  console.log("Tabla entradas_detalles NO se pudo crear", error.message);
				)
			)
			return defered.promise;
		,

		deleteTables: ()->
			defered = $q.defer();

			db.transaction( (tx)->
				tx.executeSql("DROP TABLE entradas",[], 
					(tx,results)->console.log("Tabla entradas eliminada"),
					(tx,error)->console.log("entradas, Could not delete", error.message)
				);
			);
			db.transaction( (tx)->
				tx.executeSql("DROP TABLE entradas_detalles",[], 
				  (tx,results)->console.log("Tabla entradas_detalles eliminada"),
				  (tx,error)->console.log("entradas_detalles, Could not delete", error.message)
				);
			);
			return defered.promise;
		,

		query: (sql, datos)->
			defer = $q.defer();

			if (typeof datos == "undefined" or datos == undefined)
				datos = [];

			db.transaction( (tx) ->
				tx.executeSql(sql, datos,  (tx, result) ->
					items = [];

					for row, i in result.rows
						items.push(result.rows.item(i));
					
					defer.resolve(items);
					
				, (tx,error)->
					console.log(error.message, sql, datos);
					defer.reject(error.message)
				) 
			); 
			return defer.promise;
		,

		getEntradasSinGuardar: ()->
			deferE = $q.defer();
			sql = "SELECT rowid, id, fecha, tipo, proveedor_id, cancelada, created_at FROM entradas";
			
			this.query(sql).then((r)->
				entradas = r 

				angular.forEach(entradas, (entrada, indice)->
					sql2 = "SELECT * FROM entradas_detalles";

					res.query(sql2).then((rd)->
						entrada.productos_agregados = rd
					, (rd2)->
						console.log 'Pailas trayendo detalles en Local'
						deferE.reject 'detalle entrada Local'
					)
				, this)
				$timeout(()->
					deferE.resolve entradas
				, 50)
			, (r2)->
				console.log 'Pailas trayendo entradas en Local'
				deferE.reject 'entradas Local'
			)


			return deferE.promise;
		,

		insertEntrada: (datos)->
			d = new Date()
			#ahora_string = d.getDate()  + "-" + (d.getMonth()+1) + "-" + d.getFullYear()
			fecha = d.toISOString().slice(0, 10)

			
			datos_arr = [fecha, false, d];
			sql = "INSERT INTO entradas (fecha, cancelada, created_at) VALUES (?,?,?)";

			return this.query(sql, datos_arr);

		,

		deleteEntrada: (rowid)->
			deferDel = $q.defer();
			sql 		= "DELETE FROM entradas WHERE rowid=?";

			db.transaction( (tx) ->
				tx.executeSql(sql, [rowid],  (tx, result) ->
					if result.rowsAffected > 0
						deferDel.resolve('Eliminado');
					else
						deferDel.reject('No se eliminó nada')
						console.log('No se eliminó nada')
					
				, (tx,error)->
					console.log(error.message, sql, datos);
					deferDel.reject(error.message)
				) 
			); 
			return deferDel.promise;





	}

	return res



])


