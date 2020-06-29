// import 'dart:js';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:peliculas/src/providers/peliculas_provider.dart';

import 'package:peliculas/src/search/search_delegate.dart';

import 'package:peliculas/src/widgets/card_swiper_widget.dart';

import 'package:peliculas/src/widgets/movie_horizontal.dart'; 


class HomePage extends StatelessWidget {

final peliculasProvider = new PeliculasProvider();

final estiloTexto = TextStyle(fontSize: 21, color: Colors.white);

  @override
  Widget build(BuildContext context) {

    peliculasProvider.getPopulares();                                     // Esta funcion va a retornar el listado del future pero tambien la instruccion getPopulares() va a ejecutar el Sink.add

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(icon: Icon (Icons.search), 
          onPressed: (){
           showSearch( context: context,
            delegate: DataSearch(),
            // query: 'Hola',
            );
          })
        ],
        title: Text('Cartelera de cine', style: estiloTexto),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: <Color>[
                Colors.purple[300], Colors.purpleAccent[100], Colors.pinkAccent[200], Colors.pink
                ]
            )          
            
          ),        
        ),      
      ),
      body: Container(
        color: Colors.black,                                              //es un Widget que se encarga de colocar las cosas en lugares donde el dispositivo sabe que puede desplegar 
        child: Column(
         mainAxisAlignment: MainAxisAlignment.spaceAround,               // para crear un espacio entre los dos elementos
        children: <Widget> [
          _swiperTarjetas(),
          _footer(context),
        ]
        ),
      ),

      );
      
      
    }
     



  Widget _swiperTarjetas() {

    return FutureBuilder(
      future: peliculasProvider.getEnCines(),                            // Esto regresa el future que retorna la lista de peliculas
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
       
       if (snapshot.hasData) {                                          // el hasdata significa que tiene informacion.
        return CardSwiper( peliculas: snapshot.data );
       } else {
         return Container(
           height: 400.0,
           child: Center(
             child:CircularProgressIndicator(),                        // El circularProgressIndicator se va a mostrar solo cuando no encuentro informacion o el Future se esta resolviendo
           ),
         );
       }

      
      },
    
    );
  
  }

  Widget _footer(BuildContext context) {

    return Container(
      width: double.infinity, 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          Container(
            padding: EdgeInsets.only(left: 20.0),                     // Me permite correr hacia la izquierda el texto 
            child: Text('Populares', style: estiloTexto)),
          SizedBox(height: 10.0),

          StreamBuilder(                                             // El StreamBuilder se va a ejecutar cada vez ue se emita un valor en el Stream, a diferencia del FutureBuilder que se ejecuta una sola vez
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              
              if (snapshot.hasData) {
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: peliculasProvider.getPopulares,
                  );
              } else {
                return Center( child: CircularProgressIndicator() );
              }
              
            //snapshot.data?.forEach( (p) =>print (p.title) );   =>    // el signo ? significa que hara el forEach solo si existe data
            },
          ),
        ]
      ),    // Abarca todo el espacio 
    );

  }

}