import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

public class projectOnJava {
    public static void main(String[] args) {
        File file = new File("fileForJavaProjet.txt");
        try {
            BufferedReader bufferedReader = new BufferedReader(new FileReader(file));
        }
        catch (IOException e){
            e.printStackTrace();
        }
    }
}