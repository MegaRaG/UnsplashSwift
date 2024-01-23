## Exercices

### 2-Grid.Exo1

**Description :** C’est une grille qui s’agrandit verticalement, ce qui permet de faire une liste simplement. On l’utilise car on veut faire une longue liste scrollable et car on doit définir une seule grid (la première et les autres prendront le même style).

**Types de listes :** fixes, flexibles, adaptables.

L'utilisation de colonnes flexibles dans une grille est souvent utile lorsque vous souhaitez que la disposition s'adapte dynamiquement à différentes tailles d'écrans ou de fenêtres. Les images prennent tout l’écran car on n’a pas défini une hauteur max.

### 2-Grid.Exo2

**Description :**
- `.resizable()`: Ce modificateur indique que l'image doit être redimensionnable, ce qui signifie qu'elle peut s'ajuster en taille.
- `.scaledToFill()`: Ce modificateur assure que l'image remplira entièrement le cadre dans lequel elle est placée, même si cela signifie déformer l'image.
- `.frame(width: geo.size.width, height: geo.size.height)`: Ce modificateur définit la taille du cadre de l'image en fonction de la largeur et de la hauteur de l'espace disponible, telles que fournies par le GeometryReader.
- `.clipped()`: Ce modificateur indique que tout ce qui dépasse du cadre défini par `.frame` doit être rogné.

### 3-Appel-reseau.Exo3

**Méthodes asynchrones :**
- **async/await :** async/await rend le code asynchrone plus facile à comprendre avec une syntaxe claire et intégrée dans Swift.
- **Combine :** Combine simplifie la gestion des flux de données asynchrones en offrant une syntaxe déclarative et élégante.
- **completionHandler / GCD :** GCD est parfait pour des tâches spécifiques et compatible avec du code existant basé sur des callbacks.
