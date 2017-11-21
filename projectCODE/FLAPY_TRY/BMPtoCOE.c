#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#define MAXSTRLENGTH 100

int BMPtoCOE(char *BMPfilename,char *COEfilename) 
{
	FILE *fp;
	int picwidth,picheight;
	if ((fp = fopen(BMPfilename, "rb")) == NULL){
		printf("\n�ļ�������\n");
		return 1;	
	}
	else{
		FILE *outfp=fopen(COEfilename,"w");
		fprintf(outfp,"memory_initialization_radix=16;\nmemory_initialization_vector =\n");
		short ind;
		char bm[2]; 
		fseek(fp,0L,0);
		fread(bm,2,1,fp);
		fseek(fp,28L,0);
		fread(&ind,2,1,fp);
		if(bm[0]!='B'||bm[1]!='M'||ind!=24){
			printf("\n��24λBMPͼƬ\n");
			return 1; 	
		}
		fseek(fp, 18L, 0);
		fread(&picwidth, 4, 1, fp);
		fread(&picheight, 4, 1, fp);
		fseek(fp, 54L, 0);
		printf("ͼƬ�ߴ�%d*%d\n",picwidth,picheight);
		int buf=(picwidth*3%4)?4-(picwidth*3)%4:0;
		char *tmp = (char*)malloc(sizeof(char)*buf);
		int i, j;
		unsigned char r,g,b;
		for (i = 0; i <picheight; i++,fread(tmp, buf, 1, fp))
			for (j = 0; j < picwidth; j++){
				fread(&b, 1, 1, fp);
				fread(&g, 1, 1, fp);
				fread(&r, 1, 1, fp);
				fprintf(outfp,"%x%x%x,\n",(int)(b/256.0*16),(int)(g/256.0*16),(int)(r/256.0*16)); 
			}
		free(tmp);
		fclose(fp);
		fclose(outfp);
		return 0;
	}
} 

int main()
{
	char BMPfilename[MAXSTRLENGTH],COEfilename[MAXSTRLENGTH];
	printf("������BMPͼƬ�ļ�������Ϊ24λBMPͼƬ���������չ����\n");
	scanf("%s",BMPfilename);
	strcpy(COEfilename,BMPfilename);
	strcat(BMPfilename,".bmp");
	strcat(COEfilename,".coe");
	if(!BMPtoCOE(BMPfilename,COEfilename)) 
		printf("������%s\n",COEfilename);
	system("pause");
}
