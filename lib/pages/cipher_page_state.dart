import 'package:flutter/material.dart';
import 'package:veil/data_structures/cryptext.dart';
import 'package:veil/data_structures/break_method.dart';

abstract class CipherPageState {
  /// Set the plaintext, encrypt, set the ciphertext.
  void setPlaintextThenCiphertext(Cryptext cryptext);

  /// Set the ciphertext, decrypt, set the plaintext.
  void setCiphertextThenPlaintext(Cryptext cryptext);

  /// To set the page mode.
  void onModeButtonPress(String mode);

  /// To set the breaking method.
  void setBreakMethod(BreakMethod method);
}