
import 'dart:async';

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculasProvider {

  String _apikey    = 'e0e2d958a42aa58009c5620ccae7c636';
  String _url       = 'api.themoviedb.org';
  String _language  = 'es-ES';

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

    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular', {

      'api_key'  : _apikey,
      'language' : _language,
      'page'     : _popularesPage.toString(),                 //lo convierto en String con el .toString() porque era un int segun la variable creada _popularesPage y el page debe ser un String
    });
    
    final resp = await _procesarRespuesta(url);

    _populares.addAll(resp);
    popularesSink(_populares);

    return resp;
  }

}