import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:peliculas/src/models/pelicula_model.dart';


class CardSwiper extends StatelessWidget {
 
 final List<Pelicula> peliculas;

 CardSwiper ({ @required this.peliculas });
 
 
  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;       // Permite conocer el ancho y alto del dispositivo, determinando alto y ancho de tarjetas

    return  Container(
      padding: EdgeInsets.only(top: 10.0),      // para hacer una separacion en la parte de arriba
      child: Swiper(
        layout: SwiperLayout.STACK,
        itemWidth: _screenSize.width * 0.7,    //abarca todo el ancho posible// 0.7 => 70% de ancho    
        itemHeight: _screenSize.height * 0.5,          // 0.7 => 50% de alto
        itemBuilder: (BuildContext context,int index){   //construye imagenes desde esta direccion web // El Index determina en que posicion estoy, que pelicula esta seleccionando
          return ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage( 
              image: NetworkImage( peliculas[index].getPosterImg() ),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              fit: BoxFit.cover,
            )
          );
              // El Boxfit se adpata a las dimensiones que tiene la imagen
          
        },
        itemCount: peliculas.length,
       // pagination: new SwiperPagination(),
       // control: new SwiperControl()
      ),
    );
      
   
  }
}