$env.config = ($env.config | upsert hooks {
    env_change: {
        PWD: [
            {
                condition: {|before, after| ( $after | path join .nuenv | path exists) }
                code: {|before, after| $after | path join .nuenv | from nuon | load-env }
            }

            {
                condition: {|before, after| ($after | is-not-empty) and ($before | is-not-empty) and ($after | str starts-with  $before) }
                code: {|before, after| print $"going deeper! ($before) .. ($after)" }
            }
        ]
    }
})
