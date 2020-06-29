
import 'dart:async';

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:peliculas/src/models/actores_model.dart';

import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculasProvider {

  String _apikey    = 'e0e2d958a42aa58009c5620ccae7c636';
  String _url       = 'api.themoviedb.org';
  String _language  = 'es-ES';


  bool _cargando = false;

  int _popularesPage = 0;

  List<Pelicula> _populares = new List();

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

   Function(List<Pelicula>) get popularesSink  => _popularesStreamController.sink.add;     // el get es una funcion que recibe una lista de pelicula, la funcion debe cumplir esa regla sino emitira un error cada vez que se quiera mandar algo que no sea una lista de pelicula 

   Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams() {

      _popularesStreamController?.close();
  }


  Future<List<Pelicula>> _procesarRespuesta( Uri url) async {

    final resp = await http.get(url);
    
    final decodeData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodeData['results']);

    return peliculas.items; 


  }



  Future<List<Pelicula>> getEnCines() async {            // Esto se utiliza para generar el URL
    
    final url = Uri.https(_url, '3/movie/now_playing', {

      'api_key'  : _apikey,
      'language' : _language,

    });

    return await _procesarRespuesta(url);

    //final resp = await http.get(url);                                           
                                                                                  /* Esto regresa un future y
                                                                                va a retonar toda la respuesta http y 
                                                                                  esa respuesta se almacena en una variable 
                                                                                  llamada respuesta, y se coloca el await para que espere a que se haga esa solicitud*/
    
    
    //final decodeData = json.decode(resp.body);                                  // Esto lo va a transformar en un mapa
     
      
    //  final peliculas = new Peliculas.fromJsonList(decodeData['results']);      
                                                                                /* el constructor fromjsonList se va a encargar
                                                                                de barrer cada uno de los resultados de a lista
                                                                                y generarme las peliculas, ya que eso es lo que tengo en mi pagina
                                                                                pelicula_model.dart*/
  
     // return peliculas.items;                                                   //  items es una coleccion de peliculas que se almacenan en una lista

                                                                                /* El metodo getEnCines regresa un Future
                                                                                  que hace la peticion a mi servicio "'3/movie/now_playing'" 
                                                                                  y retorna las peliculas ( peliculas.items) ya mapeadas
                                                                                  y listas para ser usadas*/           
  }

  Future<List<Pelicula>> getPopulares() async { 

    if (_cargando) return [];                                // Si no estoy cargando, _cargando es igual a true y me carga las siguientes peliculas

    _cargando = true;

    _popularesPage++;

  // print ('Cargando peliculas siguientes...');


    final url = Uri.https(_url, '3/movie/popular', {

      'api_key'  : _apikey,
      'language' : _language,
      'page'     : _popularesPage.toString(),                 //lo convierto en String con el .toString() porque era un int segun la variable creada _popularesPage y el page debe ser un String
    });
    
    final resp = await _procesarRespuesta(url);

    _populares.addAll(resp);
    popularesSink(_populares);

    _cargando = false;


    return resp;
  }

  Future<List<Actor>> getCast( String peliId ) async {

    final url = Uri.https( _url, '3/movie/$peliId/credits', {

      'api_key'  : _apikey,
      'language' : _language

    });
 
    final resp = await http.get(url);                             // se coloca await para esperar la respuesta del http que llama al url detallado arriba
    final decodedData = json.decode(resp.body);                   // Toma al body y lo transforma en un mapa/ Se almacena la respuesta del mapa/ Se toma al body se decodifica y se genera un mapa que se almacena en decodedData
    final cast = new Cast.fromJsonList(decodedData['cast']);      // Enviamos el mapa en su propriedad de cast y se envia a la instancia cast

    return cast.actores;
 }


  Future<List<Pelicula>> buscarPelicula( String query ) async {

    final url = Uri.https(_url, '3/search/movie', {
      'api_key'  : _apikey,
      'language' : _language,
      'query'    : query
    });

    return await _procesarRespuesta(url);

  }

}