module ClaseHelper
    def clase_subtitulo(clase)
        raw(clase.radical && clase.raza ?
            '<h3 class="clase-subtitulo clase-subtitulo_radical">Clase de raza y radical</h3>'
        : ( clase.radical ?
            '<h3 class="clase-subtitulo clase-subtitulo_radical"> Clase radical</h3>'
        : (clase.raza ?
            '<h3 class="clase-subtitulo clase-subtitulo_raza">Clase de raza</h3>' 
        : "")))
    end
end
