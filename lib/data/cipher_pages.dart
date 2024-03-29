import 'package:flutter/material.dart';
import 'package:veil/data_structures/alphabet.dart';
import 'package:veil/pages/page_cipher_playfair.dart';

import 'package:veil/pages/page_cipher_shift.dart';
import 'package:veil/pages/page_cipher_affine.dart';
import 'package:veil/pages/page_cipher_rail_fence.dart';
import 'package:veil/pages/page_cipher_substitution.dart';
import 'package:veil/pages/page_cipher_viginere.dart';
import 'package:veil/pages/page_cipher_ADFGVX.dart';


Map<String, Widget> getCipherPages(Alphabet defaultAlphabet) {
  return {
    'Shift Cipher' : PageCipherShift(defaultAlphabet: defaultAlphabet),
    'Affine Cipher' : PageCipherAffine(defaultAlphabet: defaultAlphabet),
    'Viginere Cipher' : PageCipherViginere(defaultAlphabet: defaultAlphabet),
    'Rail Fence Cipher' : PageCipherRailFence(defaultAlphabet: defaultAlphabet),
    'Substitution Cipher' : PageCipherSubstitution(defaultAlphabet: defaultAlphabet),
    'Playfair Cipher' : PageCipherPlayfair(defaultAlphabet: Alphabet.fromString(letters: "ABCDEFGHIKLMNOPQRSTUVWXYZ")),
    'ADFGVX Cipher' : PageCipherADFGVX(defaultAlphabet: Alphabet.fromString(letters: "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")),
  };
}