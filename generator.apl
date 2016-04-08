random_bool_matrix ← {⍵ ≥ ?⍺⍴100}
build_rooms ← {2≤ ⊃ +/+⌿ 1 0 ¯1 ∘.⊖ 1 0 ¯1 ⌽¨ ⊂⍵}
iota_repeat ← {⊃ ,/ ⍵ ⍴¨ ⍳⍵}
matrix_indices ← {⊂[2] (iota_repeat 1⌷⍵) ,[1.1] (×/⍵) ⍴ ⍳2⌷⍵}
selected_indices ← {(,⍵) / matrix_indices ⍴⍵}
laterally_adjacent ← {1= |-/ ((⍴⍺,⍵) ⍴ ~⍺=⍵) / ⍺,⍵}

q ← build_rooms 15 15 random_bool_matrix 15
i ← selected_indices q
