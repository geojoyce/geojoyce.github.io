/*
Author:Joyce George
S5 CSE-B 128
Java Lab 2
Program to implement a StringDemo class
*/
import java.util.*;
public class StringDemo
{

	public static int words(String str)//THIS FUNCTION COMPUTES THE NUMBER OF WORDS IN A STRING
	
	{	int len=str.length();
		int word=1;
	    for(int i=0;i<len;i++)
		    {
		       char ch=str.charAt(i);
		       if(ch== ' ')
			{
			    word=word+1;
			 }
		    
		    
		    }
		    return word;
	
	}
	
	public static void main(String arg [])
	{
		System.out.println("Enter the first string:");
		Scanner in = new Scanner(System.in);
		String string1 = in.nextLine();
		System.out.println("Enter the second string");
		String string2 = in.nextLine();;
		if((string1.compareTo(string2))==0)
		  {
		  System.out.println("The strings are same");
		  }
		  else
		  System.out.println("The strings entered are not same");
		  int words=1;
		  int len1=string1.length();
		  int len2=string2.length();
		  int word1=words(string1);
		  int word2=words(string2);
		System.out.println("Enter which sequence of character you want to find in " + string1);
		String Seq = in.nextLine();
		System.out.println("The length of " + string1 +" is "+len1 );
		System.out.println("The length of " + string2 +" is "+len2 );
		System.out.println("The number of words in "+ string1 +" is "+ word1);
		System.out.println("The number of words in "+ string2 +" is "+ word2);
		String upper_string1 = string1.toUpperCase();
		String upper_string2 = string2.toUpperCase();
		System.out.println("The upper case of "+ string1 +" is "+upper_string1);
		System.out.println("The upper case of "+ string2 +" is "+upper_string2);
		if((string1.contains(Seq)) == true)
		  {
		    System.out.println("Yes,the character sequence" + Seq +"is present in "+ string1);
		    }
		    else
		    System.out.println("Sorry,the character sequence" + Seq +"is not present in "+ string1);
		  
		 System.out.println("Enter any new string:");
		 String newstr=in.nextLine();
		 System.out.println("Enter the character to replace")
	
	}
}