library(DiagrammeR)
scm <- mermaid("
        graph BT

            A((postcodes))-->B{Output Areas}
            B-->C{Lower Layer Super OAs}
            C-->D[Middle Layer Super OAs]
            D-->E{Council Districts}
            C-->E
            E-->F[Counties]
            F-->G[Regions]

            G-->H{Countries}
            E-->H
            H-->Z((UK))
    
            B-->I[Postcode Sectors]
            I-->J{Postcode Districts}
            J-->K[Post Towns]
            J-->L[Postcode Areas]
            K-->Z
            L-->Z
    
            C-->M[Travel To Work Areas]
            M-->|cross-border| Z
            B-->N[Electoral Wards]
            N-->E
            B-->O[Parliament Constituencies]
            O-->G
            B-->|partial| P[County Electoral Districts]
            P-->F
            B-->|partial| Q[Parishes]
            Q-->H

            B-->|partial| S[Built-Up Division]
            S-->|cross-border| Z
            B-->|partial| T[Built-Up SubDivision]
            T-->|cross-border| Z
            B-->U|partial| [Major Towns And Cities]
            U-->E
    
            style A font-size:50px,color:yellow;
            style B fill:#EEEEEE;
            style C fill:#E5E25F;

    ", height = 1200, width = 1200
)
scm
# htmlwidgets::saveWidget(scm, '/home/atgshiny/test/schema.html')

