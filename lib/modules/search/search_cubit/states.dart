

import 'package:zenon/models/search_model.dart';

abstract class SearchStates {}

class SearchInitStates extends SearchStates {}

class SearchLoadingStates extends SearchStates {}
class SearchSuuccessStates extends SearchStates {
  final SearchModel model ;

  SearchSuuccessStates(this.model);
}
class SearchErrorStates extends SearchStates {
  final String error;

  SearchErrorStates(this.error);
}

class ChangeFormFieldState extends SearchStates {}



class ChangeFormFieldContent extends SearchStates 
{
  final String text ;

  ChangeFormFieldContent(this.text);

}