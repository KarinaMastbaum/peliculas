//Para agregar esto utilizo Shift + Ctrol + P = Paste JSON as Code

class Peliculas {

List<Pelicula> items = new List();

Peliculas();

Peliculas.fromJsonList( List<dynamic> jsonList ) {

  if (jsonList == null ) return;               // si JsonList es igual a null no devuelve nada

for ( var item in jsonList  ) {
      final pelicula = new Pelicula.fromJsonMap(item);
      items.add( pelicula );
    }

}
}


class Pelicula {
  double popularity;
  int voteCount;
  bool video; 
  String posterPath;
  int id;
  bool adult;
  String backdropPath;
  String originalLanguage;
  String originalTitle;
  List<int> genreIds;
  String title;
  double voteAverage;
  String overview;
  String releaseDate;

  Pelicula({
    this.popularity,
    this.voteCount,
    this.video,
    this.posterPath,
    this.id,
    this.adult,
    this.backdropPath,
    this.originalLanguage,
    this.originalTitle,
    this.genreIds,
    this.title,
    this.voteAverage,
    this.overview,
    this.releaseDate,
  });

  Pelicula.fromJsonMap( Map<String, dynamic> json ) {        // lo utilizo cuando quiero generar una instancia de pelicula que viene de un mapa que tiene formato Json

    popularity        = json ['popularity'] / 1;
    voteCount         = json  ['Vote_count'];
    video             = json ['video'];
    posterPath        = json ['poster_path'];
    id                = json ['id'];
    adult             = json ['adult'];
    backdropPath      = json ['backdrop_path'];
    originalLanguage  = json ['original_language'];
    originalTitle     = json ['original_title'];
    genreIds          = json ['genre_ids'].cast<int>();
    title             = json ['title'];
    voteAverage       = json ['vote_average'] / 1; // lo divido por 1 para transformarlo en un double
    overview          = json ['overview'];
    releaseDate       = json ['release_date'];



  } 
  

  getPosterImg() {

    if ( posterPath == null ) {
      return 'https://lh3.googleusercontent.com/proxy/waovtLysnxH1iTGFa233ZSJ3yRFgeohfzbGPE2ls506k2SRrwqGUmF0CrRlVutr9M_XJLSLJhz6xcZKRynm_RP9QDuYJyQWteOkE0xUJAw';
    } else {
      return'https://image.tmdb.org/t/p/w500/$posterPath';
    }

    
  
  }

}