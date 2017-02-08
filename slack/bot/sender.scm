#!/usr/bin/env gosh
(define-module slack.bot.sender
  (use rfc.http)
  (use rfc.json)
  (use rfc.uri)
  (export generate-slack-post))

(select-module slack.bot.sender)

(define (gen-body text icon-emoji name channel)
  (construct-json-string
   (list
    (cons 'text text)
    (cons 'icon_emoji icon-emoji)
    (cons 'channel channel)
    (cons 'username name))))

(define (slack-post-with-token token :key name icon channel (text ""))
  (http-post "hooks.slack.com" (string-append "/services" token) (gen-body text icon name channel) :secure #t :sink (current-output-port) :flusher (lambda _ #t)))

(define (generate-slack-post token-uri)
  (and-let* ((token (string-split token-uri "/services"))
             )
    (pa$ slack-post-with-token (cadr token)))
  )
