import 'package:dio/dio.dart';
import 'package:palaemon_passenger_app/bloc/auth_bloc/auth_bloc.dart';

abstract class API {
}

class RealAPI extends API {
  final Dio client;

  RealAPI(this.client);
}