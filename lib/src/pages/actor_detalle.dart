import 'package:flutter/material.dart';

import 'package:scooby_app/src/models/actores_model.dart';
import 'package:scooby_app/src/models/pelicula_model.dart';
import 'package:scooby_app/src/providers/actores_provider.dart';

import 'package:scooby_app/src/providers/peliculas_provider.dart';

class ActorDetalle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Actor actor = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        _crearAppbar(actor),
        SliverList(
          delegate: SliverChildListDelegate([
            SizedBox(height: 10.0),
            _descripcion(actor),
            _crearPelis(actor),
          ]),
        )
      ],
    ));
  }

  Widget _crearAppbar(Actor actor) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.redAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          actor.name,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        background: FadeInImage(
          image: NetworkImage(actor.getFoto()),
          placeholder: AssetImage('assets/img/loading.gif'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _descripcion(Actor actor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        actor.biography,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _crearPelis(Actor actor) {
    final actoresProvider = new ActoresProvider();

    return FutureBuilder(
      future: actoresProvider.getPelis(actor.id.toString()),
      builder: (context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return _crearPelisPageView(snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearPelisPageView(List<Pelicula> peliculas) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(viewportFraction: 0.3, initialPage: 1),
        itemCount: peliculas.length,
        itemBuilder: (context, i) => _peliTarjeta(peliculas[i]),
      ),
    );
  }

  Widget _peliTarjeta(Pelicula pelicula) {
    return Container(
        child: Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: FadeInImage(
            image: NetworkImage(pelicula.getPosterImg()),
            placeholder: AssetImage('assets/img/no-image.jpg'),
            height: 150.0,
            fit: BoxFit.cover,
          ),
        ),
        Text(
          pelicula.originalTitle,
          overflow: TextOverflow.ellipsis,
        )
      ],
    ));
  }
}
