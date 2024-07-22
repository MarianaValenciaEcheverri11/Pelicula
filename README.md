# Pelicula
Es el repositorio de una app construida en Swift que muestra un listado de películas segmentado por categorías, donde es posible filtrar y buscar.

# Partrón de arquitectura: MVVM

## Model:
Representa los datos que van a ser compartidos entre el ViewModel y el View. No contiene lógica de presentación ni de interfaz de usuario. Puede ser una estructura, clase o protocolo.

## View:

Define la interfaz de usuario y cómo se presenta al usuario. No contiene lógica de negocio ni de acceso a datos. Se implementa utilizando UIKit o SwiftUI.

## ViewModel

Actúa como intermediario entre el Model y la View. Prepara los datos del modelo para que sean consumidos por la vista. Maneja la lógica de presentación, como el formato de datos y la validación. Expone propiedades observables para notificar a la vista sobre cambios en los datos y se implementa como una clase Swift.


### Interacción entre componentes:

View observa las propiedades del ViewModel para detectar cambios en los datos.
View envía acciones al VistaModeloViewModel en respuesta a las interacciones del usuario.
ViewModel accede al Model para obtener o actualizar datos.
ViewModel notifica a la vista sobre cambios en los datos, lo que actualiza la interfaz de usuario.



