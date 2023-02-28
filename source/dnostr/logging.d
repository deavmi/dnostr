module dnostr.logging;

mixin template LoggerSetup()
{
    import gogga;

    // TODO: Investigate if we need the belowe (I copied it from Birchwood)
    __gshared GoggaLogger logger;
    __gshared static this()
    {
        logger = new GoggaLogger();

        version(dbg)
        {
            logger.enableDebug();
        }
    }
}