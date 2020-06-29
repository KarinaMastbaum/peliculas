import 'package:flutter/material.dart';

import 'package:peliculas/src/models/pelicula_model.dart';

import 'package:peliculas/src/providers/peliculas_provider.dart';


class DataSearch extends SearchDelegate {

  String seleccion = '';
  final peliculasProvider = new PeliculasProvider();



  final peliculas = [
    'parasitos',
    'Aves de presa',
    'Los ultimos dias del crimen',
    'Underwater',
    'Onward',
    'Bloodshot',
    'David Copperfield',
    'The Gentlemen',

  ];

  final peliculasRecientes = [
    'parasitos',
    'Aves de presa',
  ];



   @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro AppBar
    return [
      IconButton(
        icon: Icon( Icons.clear ),
        onPressed: () {
          query = '';
        },
      )
    ];
  }
  
    @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close( context, null );
      },
    );
  }
    @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }
  
   @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando la persona escribe
    if ( query.isEmpty ) {
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {

          if( snapshot.hasData ) {
            
            final peliculas = snapshot.data;

            return ListView(
              children: peliculas.map( (pelicula) {
                  return ListTile(
                    leading: FadeInImage(
                      image: NetworkImage( pelicula.getPosterImg() ),
                      placeholder: AssetImage('assets/img/no-image.jpg'),
                      width: 50.0,
                      fit: BoxFit.contain,
                    ),
                    title: Text( pelicula.title ),
                    subtitle: Text( pelicula.originalTitle ),
                    onTap: (){
                      close( context, null);
                      pelicula.uniqueId = '';
                      Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                    },
                  );
              }).toList()
            );

          } else {
            return Center(
              child: CircularProgressIndicator()
            );
          }

      },
    );

    /*final listaSugerida = (query.isEmpty) 
                                          ? peliculasRecientes
                                          : peliculas.where( 
                                            (p) => p.toLowerCase().startsWith(query.toLowerCase()) 
                                            ).toList();                                             // Esto retorna todas las peliculas que cumplen la condicion que la persona escribio
                                           

    return ListView.builder(
      itemCount: listaSugerida.length,
      itemBuilder: (context, i) {
        return ListTile(
          leading: Icon ( Icons.movie),
          title: Text(listaSugerida[i]),
          onTap: (){
            seleccion = listaSugerida[i];
            showResults( context );
          },
        );
      }


    );*/
  }



}