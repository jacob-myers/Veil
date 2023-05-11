
# Veil

An application for encrypting, decrypting, and cracking ciphers.

## Contributors

Jacob Myers.

## Project
Veil is an application for encrypting, decrypting, and cracking ciphers. The list of implemented ciphers and how they work can be found below. They currently do not extend to modern, bit-based ciphers. They are alphabet based ciphers.

### Features
 - Various ciphers with the ability encrypt and decrypt.
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

### Rail Fence Cipher
A rail fence cipher is more visual. The plaintext is laid down in an switch-backing pattern. Like a series of 'V's. It is then read across left to right line by line to obtain the ciphertext. The key consists of the number of rails \(r\) and the offset (o). Both can be chosen by the user. r is capped at 9999. o is not capped, but will be effectively in mod(r * 2 - 2). The equivalent of one full 'V'.

A visual of the 'V' shapes is displayed below the key inputs, and updated in real time as the user types and edits the key values.

### Affine Cipher
An affine cipher is a mathematical, alphabet based cipher like the shift cipher. It is an improvement to the limited keyspace of the shift cipher. It adds another variable. Rather than just shifting the plaintext value of each character by k, it multiplies the plaintext value by another variable first. It multiplies the the original character (numerically represented by it's index in the alphabet) by a, then adds b. The result is evaluated in mod n, where n is the length of the alphabet.

An affine cipher can be represented by the equation: `E(p) = ap + b (mod n)`

However, not all a within mod n will work! A value of a must also be relatively prime with n. Meaning that their greatest common divisor must be 1. This is tested in this program through the Euclidean Algorithm.

#### Tools

 - Known plaintext. Two plaintext-ciphertext character pairs must be known to extract the key (both a and b). However, the plaintext characters must be a distance apart that is relatively prime with n! For example in default English, 'I' and 'F' are represented by 8 and 5 respectively. Making them a distance of 3 apart. This is relatively prime with 26, making it valid. If you knew plaintext 'IF' encrypted to 'PQ', you could extract the key as as a = 17, b = 9.

### Substitution Cipher
Another classic cipher, this cipher involves relating each character in the alphabet to another character in the alphabet. This relation must be a one-to-one, onto function, however. Each character can only map to one other character, and each character must be mapped to. This is called a permutation. And can be represented in tabular and cycle notation. The key to a substitution cipher is a permutation of the alphabet. The user inputs this in cycle notation. It is parsed and shown visually below in both tabular and cycle notation. Updated in real time as the user changes it.

#### Tools

 - Individual frequency analysis. The count and percentage of the ciphertext that each character takes up is displayed in a list, sorted highest to lowest (can be toggled lowest to highest). If the user knows what letters in their alphabet are most common, this can help identify some letters.
 - Digram analysis. Digrams are the most useful tool in cracking an unknown substitution cipher. Like all frequency analysis methods, it relies on a decent amount of ciphertext. A digram table is made that shows the frequency of digrams using the 10 most common letters in the ciphertext. If desired, a full digram table can be opened in it's own page. It can also be sorted by least frequent letters first.