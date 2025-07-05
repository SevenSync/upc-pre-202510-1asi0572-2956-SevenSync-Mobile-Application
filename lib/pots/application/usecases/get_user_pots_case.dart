import 'package:macetech_mobile_app/pots/domain/aggregates/pot.dart';
import 'package:macetech_mobile_app/pots/domain/interfaces/repositories/i_pot_repository.dart';

class GetUserPotsUseCase {
  final IPotRepository _potRepository;

  GetUserPotsUseCase(this._potRepository);

  Future<List<Pot>> call() async {
    return await _potRepository.getUserPots();
  }
}