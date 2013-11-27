CircularPageView
==================

CircularScrollView is a custom 2D paginated scroll view that simulate endless scrolling which would return to the first page when user tries to go beyon the last page. 

A, B, [C]
D, E, F
G, H, I

When user is on page C and tries to scroll to the right, user would see a copied image of A while scrolling and actually go to A after the scrolling ends. 

[A], B, C
D, E, F
G, H, I

Scrolling to below would produce following effects

A, B, C
D, E, F
G, H, I

↓

A, B, C
[D], E, F
G, H, I

↓

A, B, C
D, E, F
[G], H, I

↓

[A], B, C
D, E, F
G, H, I


