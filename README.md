  
# Veil  
  
An application for encrypting, decrypting, and cracking ciphers. A web build can be accessed and used at this domain: https://crypto-veil.web.app  
  
## Contributors  
  
Jacob Myers.  
  
## Project  
Veil is an application for encrypting, decrypting, and cracking ciphers. The list of implemented ciphers and how they work can be found below. They currently do not extend to modern, bit-based ciphers. They are alphabet based ciphers.  
  
### Features  
 - Various ciphers with the ability to encrypt and decrypt.  
   - A master list on the home page can navigate to each implemented cipher. The keys and applicable settings for each cipher can be customized/tuned.  
 - Robust Input Editor.  
   - An input editor is located at the top of each cipher page. The left hand side is editable. Depending on the mode the user is in (Encrypt/Decrypt/Break) this may be the ciphertext or plaintext. The opposing text display is updated quickly in real time as the user edits the input. For example, if the user is in Encrypt mode, they are editing plaintext, and the ciphertext is being updated from their plaintext.  
   - Buttons line the bottom of the text display which can be used for easy manipulations of the input.  
 - Visualization of the cipher (if applicable).  
   - Many ciphers rely on a visual aspect. Like the Rail Fence Cipher. These are visualized quickly in real time as the user enters text.   
 - *Fully customizable alphabet.  
   - A custom data structure back-end's the representation of an alphabet. The alphabet can be whatever the user desires. It can include any amount of unique characters, and in any order. However, this feature is sometimes limited by the cipher itself. Some ciphers can only work with a specific size/arrangement.  
 - Cipher cracking tools.  
   - Many ciphers have a cracking mode, where one or more tools may exist that can assist in cracking a piece of ciphertext. For example, the substitution cipher has a complex digram analysis tool to view the frequency of digrams in the ciphertext. This is useful for identifying what letters they may decrypt to!  
  
### Shift Cipher  
One of the earliest ciphers. Caesar is the most famous user. The Caesar Cipher is a shift cipher with a shift (k) of 3. In this application, the user can select what shift they would like, that is between 0 and the length of the alphabet (n). In default english, this is 26. So 25 is the max shift.  
  
A shift cipher can be represented by the equation: `E(p) = p + k (mod n)`  
  
#### Tools  
  
 - Brute force. A brute force interface is provided.  
 - Known Plaintext. A known pair between a piece of ciphertext and plaintext can identify the key (k) used in the original shift. Only one plaintext-ciphertext character pair is needed to crack a shift cipher.  
  
### Affine Cipher  
An affine cipher is a mathematical, alphabet based cipher like the shift cipher. It is an improvement to the limited keyspace of the shift cipher. It adds another variable. Rather than just shifting the plaintext value of each character by k, it multiplies the plaintext value by another variable first. It multiplies the the original character (numerically represented by it's index in the alphabet) by a, then adds b. The result is evaluated in mod n, where n is the length of the alphabet.  
  
An affine cipher can be represented by the equation: `E(p) = ap + b (mod n)`  
  
However, not all a within mod n will work! A value of a must also be relatively prime with n. Meaning that their greatest common divisor must be 1. This is tested in this program through the Euclidean Algorithm.  
  
#### Tools  
  
 - Known plaintext. Two plaintext-ciphertext character pairs must be known to extract the key (both a and b). However, the plaintext characters must be a distance apart that is relatively prime with n! For example in default English, 'I' and 'F' are represented by 8 and 5 respectively. Making them a distance of 3 apart. This is relatively prime with 26, making it valid. If you knew plaintext 'IF' encrypted to 'PQ', you could extract the key as as a = 17, b = 9.  
  
### Vigenere Cipher  
The Vigenere cipher is similar to a shift cipher, but uses a keyword. To encrypt, each letter of the plaintext is shifted a value corresponding to the next letter of the keyword, looping back to the beginning when the end of the keyword is reached. For example in default English, encrypting 'HELLO' with the keyword 'IF', 'H' would be shifted by 'I' (8), 'E' would be shifted by 'F' (5), 'L' would be shifted by 'I' (8) and so on. So essentially, 'HELLO' would be lined up with 'IFIFI', and each place summed.  
  
### Rail Fence Cipher  
A rail fence cipher is more visual. The plaintext is laid down in an switch-backing pattern. Like a series of 'V's. It is then read across left to right line by line to obtain the ciphertext. The key consists of the number of rails \(r\) and the offset (o). Both can be chosen by the user. r is capped at 9999. o is not capped, but will be effectively in mod(r * 2 - 2). The equivalent of one full 'V'.  
  
A visual of the 'V' shapes is displayed below the key inputs, and updated in real time as the user types and edits the key values.  
  
### Substitution Cipher  
Another classic cipher, this cipher involves relating each character in the alphabet to another character in the alphabet. This relation must be a one-to-one, onto function, however. Each character can only map to one other character, and each character must be mapped to. This is called a permutation. And can be represented in tabular and cycle notation. The key to a substitution cipher is a permutation of the alphabet. The user inputs this in cycle notation. It is parsed and shown visually below in both tabular and cycle notation. Updated in real time as the user changes it.  
  
#### Tools  
  
 - Individual frequency analysis. The count and percentage of the ciphertext that each character takes up is displayed in a list, sorted highest to lowest (can be toggled lowest to highest). If the user knows what letters in their alphabet are most common, this can help identify some letters.  
 - Digram analysis. Digrams are the most useful tool in cracking an unknown substitution cipher. Like all frequency analysis methods, it relies on a decent amount of ciphertext. A digram table is made that shows the frequency of digrams using the 10 most common letters in the ciphertext. If desired, a full digram table can be opened in it's own page. It can also be sorted by least frequent letters first.

### Playfair Cipher
The Playfair/Wheatstone cipher was the first cipher to encrypt plaintext in pairs. It was considered obsolete by the beginning of World War 1. It uses a 5x5 grid as a key, and a 25 letter alphabet (I and J were used interchangeably). To create the 5x5 key array, the user would arrange the alphabet in order into the 5x5 array, putting the letters for the keyword in first. For instance, with a keyword PLAYFAIR: 

```
P L A Y F
I R B C D
E G H K M
N O Q S T
U V W X Z
```

To encrypt, break the plaintext into pairs. Let's take "WILLARRIVETODAY" as our plaintext. 

- If there is a double-letter in a pair, insert an X and regroup.

	- `WI LL AR RI VE TO DA Y -> WI LX LA RR IV ET OD AY -> WI LX LA RX RI VE TO DA Y`
- If there is a single letter left at the end, pad it with an X.

	- `WI LX LA RX RI VE TO DA Y -> WI LX LA RX RI VE TO DA YX`

For each pair, find the letters on the array and follow the following rules to find the ciphertext:

- If the two letters are in the **same row**, replace each letter by the letter immediately to it's **right**, wrapping around to the left of the array if necessary.
- If the two letters are in the **same column**, replace each letter by the letter immediately **below** it, wrapping around the top of the array if necessary.
- If the two letters are **not in the same row or column**, replace each letter with the letter in **it's row** and in the **column of the other letter**.

	- For example, 'HI' in the following keyarray encrypts to 'BM'. 

![Playfair Example] (/assets/readme/playfair_demo.png)

Decryption is the same process but reversed.

- If the two ciphertext letters are in the same row, shift them to the left.
- If the two ciphertext letters are in the same column, shift them up.
- If the two ciphertext letters are not in the same row or column, read the other corners of the rectangle.
