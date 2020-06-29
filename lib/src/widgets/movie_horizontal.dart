import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';




class MovieHorizontal extends StatelessWidget {

  final List<Pelicula> peliculas;

  final Function siguientePagina;

  MovieHorizontal ( { @required this.peliculas, @required this.siguientePagina } );
  
  final _pageController = new PageController(
      initialPage: 1,
      viewportFraction: 0.3,                                //que cantidad de peliculas veo en la pagina equivale a 3 en este caso),
  );


  @override
  Widget build(BuildContext context) {
    
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      
      if (_pageController.position.pixels >= _pageController.position.maxScrollExtent - 200 ) {   // Si la posicion actual es mayor o igual a la posicion maxima de pixeles entonces cargue las siguientes peliculas
        siguientePagina();
      }

    });

    return Container(
      height: _screenSize.height * 0.2,
      child: PageView.builder(                                // El page View va a renderizar toda la lista de peliculas, la diferencia del pageView del pageView.Builder es que este ultimo los renderiza bajo demanda, solo cuando son necesarios
        pageSnapping: false,
        controller:  _pageController,
        itemCount: peliculas.length,
        itemBuilder: (context, i) {
          return _tarjeta( context, peliculas [i]);
        },
        /*/children: (
          _tarjetas(context)*/
        ),
      );

  }

  Widget _tarjeta ( BuildContext context, Pelicula pelicula) {

    pelicula.uniqueId = '${ pelicula.id}-poster';

     final tarjeta = Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget> [
            Hero(
              tag: pelicula.uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                image: NetworkImage( pelicula.getPosterImg() ),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 140.0,
                ),
              ),
            ),
            SizedBox(height: 5.0),           
            Text(
              pelicula.title,
              overflow: TextOverflow.ellipsis,  //  Para modificar el texto abajo de las peliculas populares
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),

      );

    return GestureDetector(                                // Detecta los click, los Tab
      child: tarjeta,
      onTap: () {

        Navigator.pushNamed(context, 'detalle', arguments: pelicula );

      },
    );

  }


  /*List<Widget> _tarjetas(BuildContext context) {

    return peliculas.map( (pelicula) {

      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget> [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
              image: NetworkImage( pelicula.getPosterImg() ),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              fit: BoxFit.cover,
              height: 140.0,
              ),
            ),
            SizedBox(height: 5.0),           
            Text(
              pelicula.title,
              overflow: TextOverflow.ellipsis,  //  Para modificar el texto abajo de las peliculas populares
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),

      );
    
    
    }).toList();*/      // el toList se utiliza para convertirlo en listas de widget
  
  
  }

