#!/usr/bin/env stack
-- stack runghc --package language-dockerfile --package ShellCheck --install-ghc --resolver=lts-6.15
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
import           Control.Monad
import           Data.Monoid
import           Language.Dockerfile

tags = [ ("7.10.3", "7.10")
       , ("8.0.1", "8.0")
       , ("8.0.1", "latest")
       ]

main = do
    forM_ tags $ \(version, tag) -> do
        let dockerfile = tag <> ".dockerfile"
        writeFile ("./" <> dockerfile) $ toDockerfileStr $ do
            from ("mitchty/alpine-ghc" `tagged` tag)
            env [("dockerfile", dockerfile)]
            [edockerfile|
MAINTAINER Pedro Yamada <tacla.yamada@gmail.com>

VOLUME /src
WORKDIR /src

RUN ["apk", "add", "--update-cache", "linux-headers", "dev86", "docker"]
RUN ["apk", "add", "musl-dev"]

COPY [ "build.sh", "/usr/local/sbin/" ]

ENTRYPOINT [ "/usr/local/sbin/build.sh" ]
            |]
