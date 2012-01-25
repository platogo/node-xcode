{
    function merge(hash, secondHash) {
        secondHash = secondHash[0]
        for(var i in secondHash)
            hash[i] = secondHash[i]

        return hash;
    }
}

Project
  = headComment:SingleLineComment? obj:Object NewLine
    {
        var proj = Object.create(null)
        proj.project = obj

        if (headComment) {
            proj.headComment = headComment
        }

        return proj;
    }

Anything
  = Char / EOF

Object
  = "{" obj:(Definition / EmptyBody) "}"
    { return obj }

EmptyBody
  = _
    { return Object.create(null) }

Definition
  = _ head:Assignment _ tail:((Definition)*) _
    { 
      if (tail) return merge(head,tail)
      else return head
    }

Assignment
  = id:Identifier _ "=" _ val:Value ";"
    { 
      var result = Object.create(null);
      result[id.join('')] = val
      return result
    }

Identifier
  = [A-Za-z0-9]+

Value
  = obj:Object { return obj }
    / literal:Literal { return literal.join('') }

Literal
  = [^;\n]+

SingleLineComment
  = "//" _ contents:OneLineString NewLine
    { return contents }

Terminator
    = NewLine? EOF

OneLineString
  = contents:NonLine*
    { return contents.join('') }

_ "whitespace"
  = whitespace*

whitespace
  = NewLine / [\t ]

NonLine
  = !NewLine char:Char
    { return char }

NewLine
    = [\n\r]

EOF
    = !.

String
  = str:Char*
    { return str.join('') }

Char
  = .
