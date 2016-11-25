package metadata_test;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import com.drew.imaging.ImageMetadataReader;
import com.drew.imaging.ImageProcessingException;
import com.drew.lang.GeoLocation;
import com.drew.metadata.Metadata;
import com.drew.metadata.exif.GpsDirectory;


public class MetaTest {
	public static void main( String[] args ) throws ImageProcessingException {
		String FOLDER_NAME = "/home/krutarth/Desktop/ProgAssignment-01/silkroad2/tmp/";
		File[] files = new File( FOLDER_NAME ).listFiles();
		List<String> filelist = new ArrayList<String>();
		
		for( File file: files ){
			if( file.isFile() ){
				filelist.add( file.getName() );
			}
		}
		System.out.println( "test1" );
		for( int i=0; i<filelist.size(); i++ ){
			try{
//				System.out.println( filelist.get(i));
				File jpegFile = new File( FOLDER_NAME + filelist.get(i) );
				Metadata metadata = ImageMetadataReader.readMetadata( jpegFile );
				String gpsdata = extractGpsData( metadata );
	//			System.out.println( filelist.get(i) );
				System.out.println( filelist.get(i) + "," + gpsdata );
	//			System.out.println( "===================================" );
			}catch( IOException e){
//				e.printStackTrace();
				System.out.println( "Error" );
			}
		}
	}
	public static String extractGpsData( Metadata meta ){
		Collection <GpsDirectory> gpsdirs = (Collection) meta.getDirectoriesOfType( GpsDirectory.class );
		String coordinates = null;
		if( gpsdirs != null ){
			for( GpsDirectory gpsdir: gpsdirs ){
				GeoLocation geoLocation = gpsdir.getGeoLocation();
				if( geoLocation != null && !geoLocation.isZero() ){
					coordinates = Double.toString(geoLocation.getLatitude()) + "," +Double.toString(geoLocation.getLongitude());
				}
			}
		}
		return coordinates;
	}
}
