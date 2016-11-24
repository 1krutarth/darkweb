package test;

import java.awt.print.Printable;
import java.io.File;
import java.io.IOException;
import java.util.Collection;

import com.drew.imaging.ImageMetadataReader;
import com.drew.imaging.ImageProcessingException;
import com.drew.lang.GeoLocation;
import com.drew.metadata.Directory;
import com.drew.metadata.Metadata;
import com.drew.metadata.Tag;
import com.drew.metadata.exif.GpsDirectory;

import test.GpsMaker.PhotoLocation;


public class MetaDataExtractorTest {
	public static void main(String[] args) {
		File jpegFile = new File("Image path");
		Metadata metadata;
		try {
            metadata = ImageMetadataReader.readMetadata(jpegFile);

           System.out.println(metadata);
	           //getGpsData(metadata);


	   //function to find files from directory and folder recursively
           listFilesAndFilesSubDirectories("C:/Users/Dragvis/Desktop/project check",metadata);
           
		//print(metadata);
        } catch (ImageProcessingException e) {
            // handle exception
        	System.out.println("Under Image Proecssing Exception");
        } catch (IOException e) {
            // handle exception
        	System.out.println("Under IO Exception");
        }
		
		
	}

	function to get gps data from image and pass it to make a html page
	public static void getGpsData(Metadata meta)
	{
		Collection<GpsDirectory> gpsDirectories = meta.getDirectoriesOfType(GpsDirectory.class);
        if (gpsDirectories != null)
        {
        	for (GpsDirectory gpsDirectory : gpsDirectories) 
        	{
        		// Try to read out the location, making sure it's non-zero
        		GeoLocation geoLocation = gpsDirectory.getGeoLocation();
        		if (geoLocation != null && !geoLocation.isZero()) 
        		{
        			System.out.println(geoLocation);
        			makeMap(geoLocation);
        		}
        	}
        }
     }

	//function to print html page body
	public static void makeMap(GeoLocation location)
	{
		System.out.println();
        System.out.println("<!DOCTYPE html>");
        System.out.println("<html>");
        System.out.println("<head>");
        System.out.println("<meta name=\"viewport\" content=\"initial-scale=1.0, user-scalable=no\" />");
        System.out.println("<meta http-equiv=\"content-type\" content=\"text/html; charset=UTF-8\"/>");
        System.out.println("<style>html,body{height:100%;margin:0;padding:0;}#map_canvas{height:100%;}</style>");
        System.out.println("<script type=\"text/javascript\" src=\"https://maps.googleapis.com/maps/api/js?sensor=false\"></script>");
        System.out.println("<script type=\"text/javascript\">");
        System.out.println("function initialise() {");
        System.out.println("    var options = { zoom:3, mapTypeId:google.maps.MapTypeId.ROADMAP, center:new google.maps.LatLng(0.0, 0.0)};");
        System.out.println("    var map = new google.maps.Map(document.getElementById('map_canvas'), options);");
        System.out.println("    var marker;");

            System.out.println("    marker = new google.maps.Marker({");
            System.out.println("        position:new google.maps.LatLng(" + location + "),");
            System.out.println("        map:map,");
            System.out.println("        title:\"" + location + "\"});");
            System.out.println("    google.maps.event.addListener(marker, 'click', function() { document.location = \"" + location + "\"; });");
        

        System.out.println("}");
        System.out.println("</script>");
        System.out.println("</head>");
        System.out.println("<body onload=\"initialise()\">");
        System.out.println("<div id=\"map_canvas\"></div>");
        System.out.println("</body>");
        System.out.println("</html>");
	}



	//function finding files recursively
	 public static void listFilesAndFilesSubDirectories(String directoryName,Metadata meta){
	        File directory = new File(directoryName);
	        
	        //get all the files from a directory
	        File[] fList = directory.listFiles();
	        for (File file : fList){
	        	String extension = file.getAbsolutePath().substring(file.getAbsolutePath().lastIndexOf(".") + 1, file.getAbsolutePath().length());
	            if (file.isFile() && extension.equals("jpg")){	            	
	                System.out.println(file.getAbsolutePath()+", 	Extension is"+extension);
	                getGpsData(meta);
	            } else if (file.isDirectory()){
	                listFilesAndFilesSubDirectories(file.getAbsolutePath(),meta);
	            }
	        }
	    }

	//function to print metadata information
	public static void print(Metadata meta)
	{
		for (Directory directory : meta.getDirectories()) {

            //
            // Each Directory stores values in Tag objects
            //
            for (Tag tag : directory.getTags()) {
                System.out.println(tag);
            }

            //
            // Each Directory may also contain error messages
            //
            if (directory.hasErrors()) {
                for (String error : directory.getErrors()) {
                    System.err.println("ERROR: " + error);
                }
            }
        }
	}
}
