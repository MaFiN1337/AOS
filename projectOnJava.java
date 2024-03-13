import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.Arrays;

public class projectOnJava {
    public static void main(String[] args) {
        File file = new File("fileForJavaProject.txt");
        try {
            BufferedReader bufferedReader = new BufferedReader(new FileReader(file));
            bufferedReader.mark(10000);
            int lineAmount = 0;
            while (bufferedReader.readLine() != null) {
                lineAmount++;
            }
            String[] keys = new String[lineAmount];
            int[] values = new int[lineAmount];
            bufferedReader.reset();
            for (int i = 0; i < lineAmount; i++) {
                int value;
                String key = "";
                String nextLine = bufferedReader.readLine();
                boolean someBool = false;
                for (int j = 0; true; j++){
                    if (someBool){
                        value = Integer.parseInt(nextLine.substring(j));
                        break;
                    }
                    if (nextLine.charAt(j) == ' '){
                        someBool = true;
                        continue;
                    }
                    key += nextLine.charAt(j);
                }
                keys[i] = key;
                values[i] = value;
            }
            System.out.println(Arrays.toString(keys));
            System.out.println(Arrays.toString(values));
        }
        catch (IOException e){
            e.printStackTrace();
        }
    }
}