
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.IOException;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.jruby.Ruby;
import org.jruby.RubyRuntimeAdapter;
import org.jruby.embed.LocalVariableBehavior;
import org.jruby.embed.ScriptingContainer;
import org.jruby.javasupport.JavaEmbedUtils;

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 *
 * @author josh
 */
public class RubyMine extends Plugin {

    protected static final Logger log = Logger.getLogger("Minecraft");
    private String name = "RubyMine";
    private String version = "0.1";
    ScriptingContainer rubyContainer;

    private static String readFile(String path) throws IOException {
        FileInputStream stream = new FileInputStream(new File(path));
        try {
            FileChannel fc = stream.getChannel();
            MappedByteBuffer bb = fc.map(FileChannel.MapMode.READ_ONLY, 0, fc.size());
            /* Instead of using default, pass in a decoder. */
            return Charset.defaultCharset().decode(bb).toString();
        } finally {
            stream.close();
        }
    }

    @Override
    public void enable() {
        try {
            log.log(Level.INFO, "RubyMine " + version + " Enabled!");
            String rubyDir = System.getProperty("user.dir") + (File.separator + "plugins" + File.separator + "ruby" + File.separator);
            log.info("This directory contains the ruby: " + rubyDir);
            File jrubyJar = new File(System.getProperty("user.dir") + File.separator + "plugins" + File.separator + "jruby.jar");
            log.info("The file loading is: " + jrubyJar);
            RubyMineClasspathHack.addFile(jrubyJar);
            rubyContainer = new ScriptingContainer(LocalVariableBehavior.PERSISTENT);

            // time to load up the init file...
            String initFile = rubyDir + "init.rb";
            log.info("The init file is: " + initFile);
            rubyContainer.put("$LOGGER", log);
            rubyContainer.put("$SERVER", etc.getServer());
            rubyContainer.put("$ETC", etc.getInstance());
            rubyContainer.runScriptlet(new FileReader(initFile), "init.rb");
        } catch (IOException ex) {
            Logger.getLogger(RubyMine.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public void disable() {
        log.log(Level.INFO, "RubyMine {0} Disabled!", version);
    }
}
