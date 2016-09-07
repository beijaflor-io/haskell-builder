#!/usr/bin/env stack
-- stack runghc --package language-dockerfile --package ShellCheck
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
import           Control.Monad
import           Data.Monoid
import           Language.Dockerfile

tags = [ "7.10"
       , "8.0"
       , "latest"
       ]

main = do
    forM_ tags $ \tag -> do
        let dockerfile = tag <> ".dockerfile"
        writeFile ("./" <> dockerfile) $ toDockerfileStr $ do
            from ("mitchty/alpine-ghc" `tagged` tag)
            env [("dockerfile", dockerfile)]
            [edockerfile|
MAINTAINER Pedro Yamada <tacla.yamada@gmail.com>

VOLUME /src
WORKDIR /src

RUN ["apk", "add", "--update-cache", "docker"]

COPY ["build.sh", "/usr/local/sbin/"]

ENTRYPOINT ["/usr/local/sbin/build.sh"]
CMD ["--help"]
            |]
